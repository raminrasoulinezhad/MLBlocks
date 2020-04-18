`timescale 1 ns / 100 ps   
module compressor_12b_3_to_2(
		input [11:0] in1,
		inout [11:0] in2,
		input [11:0] in3,
		
		input c_in,
		
		output [11:0] s,
		output [11:0] s_c,
		output c_out
	);	

	wire [10:0] c_out_temp;

	compressor_3_to_2 compressor_3_to_2_inst0(
		.in1(in1[0]),
		.in2(in2[0]),
		.in3(in3[0]),
		.c_in(c_in),
		
		.s(s[0]),
		.s_c(s_c[0]),
		.c_out(c_out_temp[0])
	);	
	compressor_3_to_2 compressor_3_to_2_inst1(
		.in1(in1[1]),
		.in2(in2[1]),
		.in3(in3[1]),
		.c_in(c_out_temp[0]),
		
		.s(s[1]),
		.s_c(s_c[1]),
		.c_out(c_out_temp[1])
	);	
	compressor_3_to_2 compressor_3_to_2_inst2(
		.in1(in1[2]),
		.in2(in2[2]),
		.in3(in3[2]),
		.c_in(c_out_temp[1]),
		
		.s(s[2]),
		.s_c(s_c[2]),
		.c_out(c_out_temp[2])
	);	
	compressor_3_to_2 compressor_3_to_2_inst3(
		.in1(in1[3]),
		.in2(in2[3]),
		.in3(in3[3]),
		.c_in(c_out_temp[2]),
		
		.s(s[3]),
		.s_c(s_c[3]),
		.c_out(c_out_temp[3])
	);	
	compressor_3_to_2 compressor_3_to_2_inst4(
		.in1(in1[4]),
		.in2(in2[4]),
		.in3(in3[4]),
		.c_in(c_out_temp[3]),
		
		.s(s[4]),
		.s_c(s_c[4]),
		.c_out(c_out_temp[4])
	);	
	compressor_3_to_2 compressor_3_to_2_inst5(
		.in1(in1[5]),
		.in2(in2[5]),
		.in3(in3[5]),
		.c_in(c_out_temp[4]),
		
		.s(s[5]),
		.s_c(s_c[5]),
		.c_out(c_out_temp[5])
	);	
	compressor_3_to_2 compressor_3_to_2_inst6(
		.in1(in1[6]),
		.in2(in2[6]),
		.in3(in3[6]),
		.c_in(c_out_temp[5]),
		
		.s(s[6]),
		.s_c(s_c[6]),
		.c_out(c_out_temp[6])
	);	
	compressor_3_to_2 compressor_3_to_2_inst7(
		.in1(in1[7]),
		.in2(in2[7]),
		.in3(in3[7]),
		.c_in(c_out_temp[6]),
		
		.s(s[7]),
		.s_c(s_c[7]),
		.c_out(c_out_temp[7])
	);	
	compressor_3_to_2 compressor_3_to_2_inst8(
		.in1(in1[8]),
		.in2(in2[8]),
		.in3(in3[8]),
		.c_in(c_out_temp[7]),
		
		.s(s[8]),
		.s_c(s_c[8]),
		.c_out(c_out_temp[8])
	);	
	compressor_3_to_2 compressor_3_to_2_inst9(
		.in1(in1[9]),
		.in2(in2[9]),
		.in3(in3[9]),
		.c_in(c_out_temp[8]),
		
		.s(s[9]),
		.s_c(s_c[9]),
		.c_out(c_out_temp[9])
	);	
	compressor_3_to_2 compressor_3_to_2_inst10(
		.in1(in1[10]),
		.in2(in2[10]),
		.in3(in3[10]),
		.c_in(c_out_temp[9]),
		
		.s(s[10]),
		.s_c(s_c[10]),
		.c_out(c_out_temp[10])
	);	
	compressor_3_to_2 compressor_3_to_2_inst11(
		.in1(in1[11]),
		.in2(in2[11]),
		.in3(in3[11]),
		.c_in(c_out_temp[10]),
		
		.s(s[11]),
		.s_c(s_c[11]),
		.c_out(c_out)
	);	
endmodule 
