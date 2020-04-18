`timescale 1 ns / 100 ps   
module ALU_SIMD (
		input [11:0] W,
		input [11:0] Z,
		input [11:0] Y,
		input [11:0] X,
		
		input [1:0] op,
		input Z_controller,
		input S_controller,
		input W_X_Y_controller,
		
		input CARRYIN_W_X_Y_CIN_3to2,
		input CARRYIN_W_X_Y_CIN_3to2_s_c_shifted,
		input CARRYIN_W_X_Y_CIN_2to1,
		input CARRYIN_Z_W_X_Y_CIN_2to1,
		
		output [11:0] S,
		
		output CARRYOUT_W_X_Y_CIN_3to2,
		output CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted,
		output CARRYOUT_W_X_Y_CIN_2to1,
		output CARRYOUT_W_Z_W_X_Y_CIN_2to1
	);	
	
	wire [11:0] Z_Z_bar;
	assign Z_Z_bar = Z ^ {12{Z_controller}};
	
	
	wire [11:0] out_and;
	assign out_and = X & Z_Z_bar;
	
	wire [11:0] out_or;
	assign out_or = X | Z_Z_bar;
	
	wire [11:0] out_xor;
	assign out_xor = X ^ Z_Z_bar ^ Y;
	
	
	wire [11:0] temp_12b_3_to_2_compressor_s;
	wire [11:0] temp_12b_3_to_2_compressor_c;
	
	compressor_12b_3_to_2 compressor_12b_3_to_2_inst (
		.in1(W),
		.in2(X),
		.in3(Y),
		.c_in(CARRYIN_W_X_Y_CIN_3to2),
		
		.s(temp_12b_3_to_2_compressor_s),
		.s_c(temp_12b_3_to_2_compressor_c),
		.c_out(CARRYOUT_W_X_Y_CIN_3to2)
	);
	
	assign CARRYOUT_W_X_Y_CIN_3to2_s_c_shifted = temp_12b_3_to_2_compressor_c[11];
	
	wire [11:0] temp_12b_2_to_1_compressor_s;
		
	compressor_12b_2_to_1 compressor_12b_2_to_1_inst1 (
		.in1(temp_12b_3_to_2_compressor_s),
		.in2({{temp_12b_3_to_2_compressor_c[10:0]},{CARRYIN_W_X_Y_CIN_3to2_s_c_shifted}}),
		
		.c_in(CARRYIN_W_X_Y_CIN_2to1),
		
		.s(temp_12b_2_to_1_compressor_s),
		.c_out(CARRYOUT_W_X_Y_CIN_2to1)
	);	
	
	wire [11:0] temp_12b_2_to_1_compressor_s_xored;
	assign temp_12b_2_to_1_compressor_s_xored = {12{W_X_Y_controller}} ^  temp_12b_2_to_1_compressor_s;
	
	wire [11:0] S_temp_sum;
	
	compressor_12b_2_to_1 compressor_12b_2_to_1_inst2 (
		.in1(temp_12b_2_to_1_compressor_s_xored),
		.in2(Z_Z_bar),
		
		.c_in(CARRYIN_Z_W_X_Y_CIN_2to1),
		
		.s(S_temp_sum),
		.c_out(CARRYOUT_W_Z_W_X_Y_CIN_2to1)
	);	
	
	reg [11:0] S_temp_selected;
	always@(*)begin
		case (op)
			2'b00: S_temp_selected = S_temp_sum;
			2'b01: S_temp_selected = out_xor;
			2'b10: S_temp_selected = out_and;
			2'b11: S_temp_selected = out_or;
		endcase
	end
	
	assign S = S_temp_selected ^ {12{S_controller}};
	
endmodule
	
	 