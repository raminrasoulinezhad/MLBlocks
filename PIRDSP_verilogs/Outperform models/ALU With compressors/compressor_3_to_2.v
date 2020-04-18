`timescale 1 ns / 100 ps   
module compressor_3_to_2 (
		input in1,
		inout in2,
		input in3,
		
		input c_in,
		
		output s,
		output s_c,
		output c_out
	);	
		
	wire temp_s;	
	compressor_2_to_1 compressor_2_to_1_inst(
		.in1(in3),
		.in2(in2),
		.c_in(in1),
		
		.s(temp_s),
		.c_out(c_out)
	);	
		
	compressor_HA compressor_HA_inst(
		.in1(temp_s),
		.in2(c_in),
		
		.s(s),
		.c_out(s_c)
	);	
	
	
endmodule
