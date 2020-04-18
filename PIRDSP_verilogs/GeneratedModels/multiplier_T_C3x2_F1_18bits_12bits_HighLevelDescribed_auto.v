`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F1_18bits_12bits_HighLevelDescribed_auto(
		input [35:0] a,
		input [35:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [29:0] result_0,
		output reg [29:0] result_1,
		output reg [7:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_18x12	= 2'b00;
parameter mode_sum_6x6	= 2'b1;
parameter mode_sum_3x3	= 2'b10;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;

// input of partial multipliers
reg [5:0] A_0;
reg [5:0] A_1;
reg [5:0] A_2;
reg [5:0] A_3;
reg [5:0] A_4;
reg [5:0] A_5;

reg [5:0] B_0;
reg [5:0] B_1;
reg [5:0] B_2;
reg [5:0] B_3;
reg [5:0] B_4;
reg [5:0] B_5;

wire [11:0] C_0;
wire [11:0] C_1;
wire [11:0] C_2;
wire [11:0] C_3;
wire [11:0] C_4;
wire [11:0] C_5;

reg A_sign_0;
reg A_sign_1;
reg A_sign_2;
reg A_sign_3;
reg A_sign_4;
reg A_sign_5;

reg B_sign_0;
reg B_sign_1;
reg B_sign_2;
reg B_sign_3;
reg B_sign_4;
reg B_sign_5;

// to assign the input to sub multipliers 
always @(*) begin
	case (mode_SIMD)
		1'b0: begin
			A_0 = a[5:0];
			A_1 = a[11:6];
			A_4 = a[17:12];
			A_2 = a[5:0];
			A_3 = a[11:6];
			A_5 = a[17:12];

			B_0 = b[5:0];
			B_1 = b[5:0];
			B_4 = b[5:0];
			B_2 = b[11:6];
			B_3 = b[11:6];
			B_5 = b[11:6];
		end
		1'b1: begin
			A_0 = a[5:0];
			A_1 = a[11:6];
			A_4 = a[29:24];
			A_2 = a[17:12];
			A_3 = a[23:18];
			A_5 = a[35:30];

			B_0 = b[5:0];
			B_1 = b[11:6];
			B_4 = b[29:24];
			B_2 = b[17:12];
			B_3 = b[23:18];
			B_5 = b[35:30];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_18x12: begin
			mode_SIMD = 1'b0;
			A_sign_0 = 1'b0;
			A_sign_1 = 1'b0;
			A_sign_4 = a_sign;
			A_sign_2 = 1'b0;
			A_sign_3 = 1'b0;
			A_sign_5 = a_sign;

			B_sign_0 = 1'b0;
			B_sign_1 = 1'b0;
			B_sign_4 = 1'b0;
			B_sign_2 = b_sign;
			B_sign_3 = b_sign;
			B_sign_5 = b_sign;
		end
		default: begin
			mode_SIMD = 1'b1;
			A_sign_0 = a_sign;
			A_sign_1 = a_sign;
			A_sign_4 = a_sign;
			A_sign_2 = a_sign;
			A_sign_3 = a_sign;
			A_sign_5 = a_sign;

			B_sign_0 = b_sign;
			B_sign_1 = b_sign;
			B_sign_4 = b_sign;
			B_sign_2 = b_sign;
			B_sign_3 = b_sign;
			B_sign_5 = b_sign;
		end
	endcase
end

// Assigning half mode signals
assign FULL = (mode == mode_18x12);
assign HALF_0 = (mode == mode_sum_6x6);
assign HALF_1 = (mode == mode_sum_3x3);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_0)
);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_1)
);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst2(
	.A(A_2),
	.B(B_2),

	.A_sign(A_sign_2),
	.B_sign(B_sign_2),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_2)
);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst3(
	.A(A_3),
	.B(B_3),

	.A_sign(A_sign_3),
	.B_sign(B_sign_3),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_3)
);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst4(
	.A(A_4),
	.B(B_4),

	.A_sign(A_sign_4),
	.B_sign(B_sign_4),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_4)
);

multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto		multiplier_S_C3x2_F1_6bits_6bits_HighLevelDescribed_auto_inst5(
	.A(A_5),
	.B(B_5),

	.A_sign(A_sign_5),
	.B_sign(B_sign_5),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),

	.C(C_5)
);


// to implement shifters for SIMD modes
reg [29:0] C_0_shifted;
reg [29:0] C_1_shifted;
reg [29:0] C_2_shifted;
reg [29:0] C_3_shifted;
reg [29:0] C_4_shifted;
reg [29:0] C_5_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{18{(C_0[11])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{12{(C_1[11])&((A_sign_1)|(B_sign_1))}}, {C_1}, {6{1'b0}}};
			C_4_shifted = {{6{(C_4[11])&((A_sign_4)|(B_sign_4))}}, {C_4}, {12{1'b0}}};
			C_2_shifted = {{12{(C_2[11])&((A_sign_2)|(B_sign_2))}}, {C_2}, {6{1'b0}}};
			C_3_shifted = {{6{(C_3[11])&((A_sign_3)|(B_sign_3))}}, {C_3}, {12{1'b0}}};
			C_5_shifted = {{C_5}, {18{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{12{1'b0}}, {C_0}, {C_0[5:0]}};
			C_1_shifted = {{12{1'b0}}, {C_1}, {6{1'b0}}};
			C_4_shifted = {{C_4}, {6{1'b0}}, {12{1'b0}}};
			C_2_shifted = {{12{1'b0}}, {C_2}, {6{1'b0}}};
			C_3_shifted = {{C_3}, {6{1'b0}}, {12{1'b0}}};
			C_5_shifted = {{C_5}, {18{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [29:0] result_temp_0;
reg [31:0] result_temp_1;
always @ (*) begin
	result_temp_1 [11:0] = 12'b0;
	result_1 [11:0] = result_temp_1 [11:0];
	result_temp_0 [17:0] = {{2{((C_0_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_0_shifted [11:0]}} + {{2{((C_1_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_1_shifted [11:0]}} + {{2{((C_2_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_2_shifted [11:0]}} + {{2{((C_3_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_3_shifted [11:0]}} + {{2{((C_4_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_4_shifted [11:0]}} + {{2{((C_5_shifted[11])&(HALF_1))&((a_sign|b_sign))}},{C_5_shifted [11:0]}};
	result_0 [17:0] = {{(result_temp_0 [17:12])&(~({6{HALF_1}}))},{result_temp_0 [11:0]}};
	result_SIDM_carry[1:0] = result_temp_0 [13:12];
	result_temp_1 [23:12] = {{2{((C_0_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_0_shifted [17:12]}} + {{2{((C_1_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_1_shifted [17:12]}} + {{2{((C_2_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_2_shifted [17:12]}} + {{2{((C_3_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_3_shifted [17:12]}} + {{2{((C_4_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_4_shifted [17:12]}} + {{2{((C_5_shifted[17])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_5_shifted [17:12]}};
	result_1 [23:12] = {{(result_temp_1 [23:18])&(~({6{(HALF_0)|(HALF_1)}}))},{result_temp_1 [17:12]}};
	result_SIDM_carry[3:2] = result_temp_1 [19:18];
	result_temp_0 [29:18] = {{2{((C_0_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_0_shifted [23:18]}} + {{2{((C_1_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_1_shifted [23:18]}} + {{2{((C_2_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_2_shifted [23:18]}} + {{2{((C_3_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_3_shifted [23:18]}} + {{2{((C_4_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_4_shifted [23:18]}} + {{2{((C_5_shifted[23])&(HALF_1))&((a_sign|b_sign))}},{C_5_shifted [23:18]}};
	result_0 [29:18] = {{(result_temp_0 [29:24])&(~({6{HALF_1}}))},{result_temp_0 [23:18]}};
	result_SIDM_carry[5:4] = result_temp_0 [25:24];
	result_temp_1 [31:24] = {{2{((C_0_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_0_shifted [29:24]}} + {{2{((C_1_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_1_shifted [29:24]}} + {{2{((C_2_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_2_shifted [29:24]}} + {{2{((C_3_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_3_shifted [29:24]}} + {{2{((C_4_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_4_shifted [29:24]}} + {{2{((C_5_shifted[29])&((HALF_0)|(HALF_1)))&((a_sign|b_sign))}},{C_5_shifted [29:24]}};
	result_1 [29:24] = result_temp_1 [29:24];
	result_SIDM_carry[7:6] = result_temp_1 [31:30];
end


endmodule
