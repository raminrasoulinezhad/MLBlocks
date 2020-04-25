module accumulator (

		clk, 
		reset,

		acc_mode,
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

	///////// IOs
	input clk;
	input reset;

	input acc_mode;
	input res_in_select;

	input signed [WIDTH-1:0] res_in_h;
	input signed [WIDTH-1:0] res_in_v;

	input signed [WIDTH-1:0] shifter_res;

	output signed [WIDTH-1:0] res_out_h;
	output signed [WIDTH-1:0] res_out_v;

	///////// internal signals
	wire [WIDTH-1:0] res_in;

	reg signed [WIDTH-1:0] acc;

	assign res_in = (res_in_select == 1'b1) ? res_in_v : res_in_h;

	generate  

		if (TYPE == "FEEDBACK") begin 
			always @(posedge clk)begin
				if (reset) begin
					acc <= 0;
				end else begin
					if (acc_mode == 1'b0) begin
						acc <= res_in + shifter_res;
					end else begin
						acc <= acc + shifter_res;
					end 
				end 
			end
		end 
		
		else if (TYPE == "FEEDFORWARD") begin 
			always @(posedge clk)begin
				if (reset) begin
					acc <= 0;
				end else begin
					acc <= res_in + shifter_res;
				end 
			end
		end 
	endgenerate

	assign res_out_h = acc;
	assign res_out_v = acc;

endmodule 
