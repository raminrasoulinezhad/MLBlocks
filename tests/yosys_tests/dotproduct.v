module dotproduct #(IN_W=8, DOT_ARRAY=6, DOT_SIZE=3, ACC_SIZE=32)(
		input clk,
		input reset,

		input signed [DOT_ARRAY*IN_W*DOT_SIZE-1:0] act,
		input signed [DOT_ARRAY*IN_W*DOT_SIZE-1:0] weight,

		input signed [DOT_ARRAY*ACC_SIZE-1:0] out_partial,

		output signed reg [ACC_SIZE-1:0] out
	);

	localparam DOT_RESULT_SIZE = IN_W + $clog2(DOT_SIZE);

	reg signed [ACC_SIZE-1:0] out_tempt; 

	integer i;
	always @ (*) begin 
		out_tempt = out_partial;
		for (i = 0; i < DOT_SIZE; i = i + 1)begin 
			out_tempt = out_tempt + act[((i+1)*IN_W)-1:(i*IN_W)] * weight[((i+1)*IN_W)-1:(i*IN_W)];  
		end 
	end 

	always @ (posedge clk)begin
		if (reset == 1'b1)begin 
			out <= 0;
		end else begin
			out <= out_tempt;
		end  
	end 

endmodule 
