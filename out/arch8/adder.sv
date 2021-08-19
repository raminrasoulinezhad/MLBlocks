module adder(
		clk, 

		a,
		b,
		
		c
	);

	parameter WIDTH = 32;

	input clk;

	input signed [WIDTH-1:0] a;
	input signed [WIDTH-1:0] b;

	
	output reg signed [WIDTH-1:0] c;

	always @ (posedge clk)begin 
		c <= a + b;
	end

endmodule 

