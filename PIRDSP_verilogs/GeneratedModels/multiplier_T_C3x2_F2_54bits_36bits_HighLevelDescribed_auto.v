`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F2_54bits_36bits_HighLevelDescribed_auto(
		input [107:0] a,
		input [107:0] b,
		
		input a_sign,
		input b_sign,
		
		input [1:0] mode,
		
		output reg [89:0] result_0,
		output reg [89:0] result_1,
		output reg [15:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_54x36	= 2'b00;
parameter mode_sum_18x18	= 2'b1;
parameter mode_sum_9x9	= 2'b10;
parameter mode_sum_4x4	= 2'b11;
// internal signal for half mode detection
wire HALF_0;
wire HALF_1;
wire HALF_2;

// input of partial multipliers
reg [17:0] A_0;
reg [17:0] A_1;
reg [17:0] A_2;
reg [17:0] A_3;
reg [17:0] A_4;
reg [17:0] A_5;

reg [17:0] B_0;
reg [17:0] B_1;
reg [17:0] B_2;
reg [17:0] B_3;
reg [17:0] B_4;
reg [17:0] B_5;

wire [35:0] C_0;
wire [35:0] C_1;
wire [35:0] C_2;
wire [35:0] C_3;
wire [35:0] C_4;
wire [35:0] C_5;

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
			A_0 = a[17:0];
			A_1 = a[35:18];
			A_4 = a[53:36];
			A_2 = a[17:0];
			A_3 = a[35:18];
			A_5 = a[53:36];

			B_0 = b[17:0];
			B_1 = b[17:0];
			B_4 = b[17:0];
			B_2 = b[35:18];
			B_3 = b[35:18];
			B_5 = b[35:18];
		end
		1'b1: begin
			A_0 = a[17:0];
			A_1 = a[35:18];
			A_4 = a[89:72];
			A_2 = a[53:36];
			A_3 = a[71:54];
			A_5 = a[107:90];

			B_0 = b[17:0];
			B_1 = b[35:18];
			B_4 = b[89:72];
			B_2 = b[53:36];
			B_3 = b[71:54];
			B_5 = b[107:90];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_54x36: begin
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
assign FULL = (mode == mode_54x36);
assign HALF_0 = (mode == mode_sum_18x18);
assign HALF_1 = (mode == mode_sum_9x9);
assign HALF_2 = (mode == mode_sum_4x4);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_0)
);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_1)
);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst2(
	.A(A_2),
	.B(B_2),

	.A_sign(A_sign_2),
	.B_sign(B_sign_2),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_2)
);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst3(
	.A(A_3),
	.B(B_3),

	.A_sign(A_sign_3),
	.B_sign(B_sign_3),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_3)
);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst4(
	.A(A_4),
	.B(B_4),

	.A_sign(A_sign_4),
	.B_sign(B_sign_4),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_4)
);

multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto		multiplier_S_C3x2_F2_18bits_18bits_HighLevelDescribed_auto_inst5(
	.A(A_5),
	.B(B_5),

	.A_sign(A_sign_5),
	.B_sign(B_sign_5),

	.HALF_0(HALF_0 | FULL),
	.HALF_1(HALF_1),
	.HALF_2(HALF_2),

	.C(C_5)
);


// to implement shifters for SIMD modes
reg [89:0] C_0_shifted;
reg [89:0] C_1_shifted;
reg [89:0] C_2_shifted;
reg [89:0] C_3_shifted;
reg [89:0] C_4_shifted;
reg [89:0] C_5_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{54{(C_0[35])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{36{(C_1[35])&((A_sign_1)|(B_sign_1))}}, {C_1}, {18{1'b0}}};
			C_4_shifted = {{18{(C_4[35])&((A_sign_4)|(B_sign_4))}}, {C_4}, {36{1'b0}}};
			C_2_shifted = {{36{(C_2[35])&((A_sign_2)|(B_sign_2))}}, {C_2}, {18{1'b0}}};
			C_3_shifted = {{18{(C_3[35])&((A_sign_3)|(B_sign_3))}}, {C_3}, {36{1'b0}}};
			C_5_shifted = {{C_5}, {54{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{36{1'b0}}, {C_0}, {C_0[17:0]}};
			C_1_shifted = {{36{1'b0}}, {C_1}, {18{1'b0}}};
			C_4_shifted = {{C_4}, {18{1'b0}}, {36{1'b0}}};
			C_2_shifted = {{36{1'b0}}, {C_2}, {18{1'b0}}};
			C_3_shifted = {{C_3}, {18{1'b0}}, {36{1'b0}}};
			C_5_shifted = {{C_5}, {54{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [89:0] result_temp_0;
reg [91:0] result_temp_1;
always @ (*) begin
	result_temp_1 [25:0] = 26'b0;
	result_1 [25:0] = result_temp_1 [25:0];
	result_temp_0 [35:0] = {{2{((C_0_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [25:0]}} + {{2{((C_1_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [25:0]}} + {{2{((C_2_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [25:0]}} + {{2{((C_3_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [25:0]}} + {{2{((C_4_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [25:0]}} + {{2{((C_5_shifted[25])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [25:0]}};
	result_0 [35:0] = {{(result_temp_0 [35:26])&(~({10{HALF_2}}))},{result_temp_0 [25:0]}};
	result_SIDM_carry[1:0] = result_temp_0 [27:26];
	result_temp_1 [43:26] = {{2{((C_0_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [35:26]}} + {{2{((C_1_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [35:26]}} + {{2{((C_2_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [35:26]}} + {{2{((C_3_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [35:26]}} + {{2{((C_4_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [35:26]}} + {{2{((C_5_shifted[35])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [35:26]}};
	result_1 [43:26] = {{(result_temp_1 [43:36])&(~({8{(HALF_1)|(HALF_2)}}))},{result_temp_1 [35:26]}};
	result_SIDM_carry[3:2] = result_temp_1 [37:36];
	result_temp_0 [53:36] = {{2{((C_0_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [43:36]}} + {{2{((C_1_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [43:36]}} + {{2{((C_2_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [43:36]}} + {{2{((C_3_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [43:36]}} + {{2{((C_4_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [43:36]}} + {{2{((C_5_shifted[43])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [43:36]}};
	result_0 [53:36] = {{(result_temp_0 [53:44])&(~({10{HALF_2}}))},{result_temp_0 [43:36]}};
	result_SIDM_carry[5:4] = result_temp_0 [45:44];
	result_temp_1 [61:44] = {{2{((C_0_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [53:44]}} + {{2{((C_1_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [53:44]}} + {{2{((C_2_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [53:44]}} + {{2{((C_3_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [53:44]}} + {{2{((C_4_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [53:44]}} + {{2{((C_5_shifted[53])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [53:44]}};
	result_1 [61:44] = {{(result_temp_1 [61:54])&(~({8{((HALF_0)|(HALF_1))|(HALF_2)}}))},{result_temp_1 [53:44]}};
	result_SIDM_carry[7:6] = result_temp_1 [55:54];
	result_temp_0 [71:54] = {{2{((C_0_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [61:54]}} + {{2{((C_1_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [61:54]}} + {{2{((C_2_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [61:54]}} + {{2{((C_3_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [61:54]}} + {{2{((C_4_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [61:54]}} + {{2{((C_5_shifted[61])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [61:54]}};
	result_0 [71:54] = {{(result_temp_0 [71:62])&(~({10{HALF_2}}))},{result_temp_0 [61:54]}};
	result_SIDM_carry[9:8] = result_temp_0 [63:62];
	result_temp_1 [79:62] = {{2{((C_0_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [71:62]}} + {{2{((C_1_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [71:62]}} + {{2{((C_2_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [71:62]}} + {{2{((C_3_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [71:62]}} + {{2{((C_4_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [71:62]}} + {{2{((C_5_shifted[71])&((HALF_1)|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [71:62]}};
	result_1 [79:62] = {{(result_temp_1 [79:72])&(~({8{(HALF_1)|(HALF_2)}}))},{result_temp_1 [71:62]}};
	result_SIDM_carry[11:10] = result_temp_1 [73:72];
	result_temp_0 [89:72] = {{2{((C_0_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_0_shifted [79:72]}} + {{2{((C_1_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_1_shifted [79:72]}} + {{2{((C_2_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_2_shifted [79:72]}} + {{2{((C_3_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_3_shifted [79:72]}} + {{2{((C_4_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_4_shifted [79:72]}} + {{2{((C_5_shifted[79])&(HALF_2))&((a_sign|b_sign))}},{C_5_shifted [79:72]}};
	result_0 [89:72] = {{(result_temp_0 [89:80])&(~({10{HALF_2}}))},{result_temp_0 [79:72]}};
	result_SIDM_carry[13:12] = result_temp_0 [81:80];
	result_temp_1 [91:80] = {{2{((C_0_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_0_shifted [89:80]}} + {{2{((C_1_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_1_shifted [89:80]}} + {{2{((C_2_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_2_shifted [89:80]}} + {{2{((C_3_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_3_shifted [89:80]}} + {{2{((C_4_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_4_shifted [89:80]}} + {{2{((C_5_shifted[89])&(((HALF_0)|(HALF_1))|(HALF_2)))&((a_sign|b_sign))}},{C_5_shifted [89:80]}};
	result_1 [89:80] = result_temp_1 [89:80];
	result_SIDM_carry[15:14] = result_temp_1 [91:90];
end


endmodule
