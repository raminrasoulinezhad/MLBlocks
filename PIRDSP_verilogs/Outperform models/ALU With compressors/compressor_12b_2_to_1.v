`timescale 1 ns / 100 ps   
module compressor_12b_2_to_1 (
		input [11:0] in1,
		inout [11:0] in2,
		
		input c_in,
		
		output [11:0] s,
		output c_out
	);	
		
	wire [10:0] c_out_temp;	
	
	compressor_2_to_1 inst0	(.in1(in1[0]), 	.in2(in2[0]), 	.c_in(c_in), 			   			.s(s[0]), 		.c_out(c_out_temp[0]));	
	compressor_2_to_1 inst1	(.in1(in1[1]), 	.in2(in2[1]), 	.c_in(c_out_temp[0]), 	.s(s[1]), 		.c_out(c_out_temp[1]));	
	compressor_2_to_1 inst2	(.in1(in1[2]), 	.in2(in2[2]), 	.c_in(c_out_temp[1]), 	.s(s[2]), 		.c_out(c_out_temp[2]));	
	compressor_2_to_1 inst3	(.in1(in1[3]), 	.in2(in2[3]), 	.c_in(c_out_temp[2]), 	.s(s[3]), 		.c_out(c_out_temp[3]));	
	compressor_2_to_1 inst4	(.in1(in1[4]), 	.in2(in2[4]), 	.c_in(c_out_temp[3]), 	.s(s[4]), 		.c_out(c_out_temp[4]));	
	compressor_2_to_1 inst5	(.in1(in1[5]), 	.in2(in2[5]), 	.c_in(c_out_temp[4]), 	.s(s[5]), 		.c_out(c_out_temp[5]));	
	compressor_2_to_1 inst6	(.in1(in1[6]), 	.in2(in2[6]), 	.c_in(c_out_temp[5]), 	.s(s[6]), 		.c_out(c_out_temp[6]));	
	compressor_2_to_1 inst7	(.in1(in1[7]), 	.in2(in2[7]), 	.c_in(c_out_temp[6]), 	.s(s[7]), 		.c_out(c_out_temp[7]));	
	compressor_2_to_1 inst8	(.in1(in1[8]), 	.in2(in2[8]), 	.c_in(c_out_temp[7]), 	.s(s[8]), 		.c_out(c_out_temp[8]));	
	compressor_2_to_1 inst9	(.in1(in1[9]), 	.in2(in2[9]), 	.c_in(c_out_temp[8]), 	.s(s[9]), 		.c_out(c_out_temp[9]));	
	compressor_2_to_1 inst10	(.in1(in1[10]), 	.in2(in2[10]), 	.c_in(c_out_temp[9]), 	.s(s[10]), 	.c_out(c_out_temp[10]));	
	compressor_2_to_1 inst11	(.in1(in1[11]), 	.in2(in2[11]), 	.c_in(c_out_temp[10]), 	.s(s[11]), 	.c_out(c_out));	
	
endmodule
