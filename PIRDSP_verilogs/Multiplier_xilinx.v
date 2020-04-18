`timescale 1 ns / 100 ps  
module Multiplier_xilinx (

		input clk,

		input signed [26:0] a,
		input signed [17:0] b,
		output signed [44:0] result1,
		output signed [44:0] result2
 	); 
	
	// parmeters
	parameter input_freezed = 1'b0;
	
	
	///////////////////////
	reg signed [26:0] a_reg;
	reg signed [17:0] b_reg;
	
	always @ (posedge clk) begin
		a_reg <= a;
		b_reg <= b;
	end	
	
	wire signed [26:0] a_temp;
	wire signed [17:0] b_temp;
	
	assign a_temp = (input_freezed) ? a_reg : a;
	assign b_temp = (input_freezed) ? b_reg : b;
	///////////////////////
	
	
	
	wire signed [9:0] b_LSB;
	wire signed [9:0] b_MSB;
	
	assign b_LSB[8:0] = b_temp[8:0];
	assign b_LSB[9] = 1'b0;
	
	assign b_MSB[8:0] = b_temp[17:9];
	assign b_MSB[9] = b_temp[17];
	
	wire signed [36:0] r_1; 
	wire signed [36:0] r_2;
	
	assign r_1 = (a_temp) * (b_LSB);
	assign r_2 = (a_temp) * (b_MSB);
	
	
	assign result1 = {{8{r_1[36]}},{r_1}};									
	assign result2 = {{r_2[35:0]},{9'b0_0000_0000}};				

endmodule
