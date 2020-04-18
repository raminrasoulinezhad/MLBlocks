`timescale 1 ns / 100 ps   
module compressor_HA (
		input in1,
		inout in2,
				
		output s,
		output c_out
	);	
		
	xor (s, in1, in2);

	and(c_out, in1, in2); 

endmodule
