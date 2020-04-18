`timescale 1 ns / 100 ps   
module compressor_2_to_1 (
		input in1,
		inout in2,
		
		input c_in,
		
		output s,
		output c_out
	);	
		
	wire temp_xor;	
	xor ints1(temp_xor, in1, in2);
	xor ints2(s, c_in, temp_xor);
	
	wire temp_and1;
	and ints3(temp_and1, in1, in2); 
	
	wire temp_and2;
	and ints4(temp_and2, c_in, temp_xor); 
	
	or ints5(c_out, temp_and1, temp_and2); 
	
endmodule
