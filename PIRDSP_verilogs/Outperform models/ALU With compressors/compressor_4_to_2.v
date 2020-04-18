`timescale 1 ns / 100 ps   
module compressor_4_to_2 (
		input in1,
		inout in2,
		input in3,
		inout in4,
		
		input c_in,
		
		output s,
		output s_c,
		output c_out
	);	
		
	wire temp_s;	
	compressor_2_to_1 compressor_2_to_1_inst1(
		.in1(in4),
		.in2(in3),
		.c_in(in2),
		
		.s(temp_s),
		.c_out(c_out)
	);	
	
	compressor_2_to_1 compressor_2_to_1_inst2(
		.in1(temp_s),
		.in2(in1),
		.c_in(c_in),
		
		.s(s),
		.c_out(s_c)
	);	
	
	
endmodule
