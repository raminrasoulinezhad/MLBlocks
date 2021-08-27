module mux(
		a,
		b,
		s,
		
		c
	);

	parameter WIDTH = 32;
	
	input signed [WIDTH-1:0] a;
	input signed [WIDTH-1:0] b;
	input s;

	
	output signed [WIDTH-1:0] c;

	assign c = (s == 1'b1) ? a : b;

endmodule 

