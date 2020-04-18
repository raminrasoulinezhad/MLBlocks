`timescale 1 ns / 100 ps  
module multiplier_T_C3x2_F0_27bits_18bits_HighLevelDescribed_auto(
		input [53:0] a,
		input [53:0] b,
		
		input a_sign,
		input b_sign,
		
		input [0:0] mode,
		
		output reg [44:0] result_0,
		output reg [44:0] result_1,
		output reg [3:0] result_SIDM_carry
	);

// functionality modes 
parameter mode_27x18	= 1'b00;
parameter mode_sum_9x9	= 1'b1;
// internal signal for half mode detection
wire HALF_0;

// input of partial multipliers
reg [8:0] A_0;
reg [8:0] A_1;
reg [8:0] A_2;
reg [8:0] A_3;
reg [8:0] A_4;
reg [8:0] A_5;

reg [8:0] B_0;
reg [8:0] B_1;
reg [8:0] B_2;
reg [8:0] B_3;
reg [8:0] B_4;
reg [8:0] B_5;

wire [17:0] C_0;
wire [17:0] C_1;
wire [17:0] C_2;
wire [17:0] C_3;
wire [17:0] C_4;
wire [17:0] C_5;

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
			A_0 = a[8:0];
			A_1 = a[17:9];
			A_4 = a[26:18];
			A_2 = a[8:0];
			A_3 = a[17:9];
			A_5 = a[26:18];

			B_0 = b[8:0];
			B_1 = b[8:0];
			B_4 = b[8:0];
			B_2 = b[17:9];
			B_3 = b[17:9];
			B_5 = b[17:9];
		end
		1'b1: begin
			A_0 = a[8:0];
			A_1 = a[17:9];
			A_4 = a[44:36];
			A_2 = a[26:18];
			A_3 = a[35:27];
			A_5 = a[53:45];

			B_0 = b[8:0];
			B_1 = b[17:9];
			B_4 = b[44:36];
			B_2 = b[26:18];
			B_3 = b[35:27];
			B_5 = b[53:45];
		end
	endcase
end

//sign controller
reg mode_SIMD;
always @(*) begin
	case (mode)
		mode_27x18: begin
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
assign FULL = (mode == mode_27x18);
assign HALF_0 = (mode == mode_sum_9x9);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst0(
	.A(A_0),
	.B(B_0),

	.A_sign(A_sign_0),
	.B_sign(B_sign_0),

	.HALF_0(HALF_0 | FULL),

	.C(C_0)
);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst1(
	.A(A_1),
	.B(B_1),

	.A_sign(A_sign_1),
	.B_sign(B_sign_1),

	.HALF_0(HALF_0 | FULL),

	.C(C_1)
);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst2(
	.A(A_2),
	.B(B_2),

	.A_sign(A_sign_2),
	.B_sign(B_sign_2),

	.HALF_0(HALF_0 | FULL),

	.C(C_2)
);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst3(
	.A(A_3),
	.B(B_3),

	.A_sign(A_sign_3),
	.B_sign(B_sign_3),

	.HALF_0(HALF_0 | FULL),

	.C(C_3)
);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst4(
	.A(A_4),
	.B(B_4),

	.A_sign(A_sign_4),
	.B_sign(B_sign_4),

	.HALF_0(HALF_0 | FULL),

	.C(C_4)
);

multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto		multiplier_S_C3x2_F0_9bits_9bits_HighLevelDescribed_auto_inst5(
	.A(A_5),
	.B(B_5),

	.A_sign(A_sign_5),
	.B_sign(B_sign_5),

	.HALF_0(HALF_0 | FULL),

	.C(C_5)
);


// to implement shifters for SIMD modes
reg [44:0] C_0_shifted;
reg [44:0] C_1_shifted;
reg [44:0] C_2_shifted;
reg [44:0] C_3_shifted;
reg [44:0] C_4_shifted;
reg [44:0] C_5_shifted;
always @ (*) begin
	case (mode_SIMD)
		1'b0: begin
			C_0_shifted = {{27{(C_0[17])&((A_sign_0)|(B_sign_0))}}, {C_0}};
			C_1_shifted = {{18{(C_1[17])&((A_sign_1)|(B_sign_1))}}, {C_1}, {9{1'b0}}};
			C_4_shifted = {{9{(C_4[17])&((A_sign_4)|(B_sign_4))}}, {C_4}, {18{1'b0}}};
			C_2_shifted = {{18{(C_2[17])&((A_sign_2)|(B_sign_2))}}, {C_2}, {9{1'b0}}};
			C_3_shifted = {{9{(C_3[17])&((A_sign_3)|(B_sign_3))}}, {C_3}, {18{1'b0}}};
			C_5_shifted = {{C_5}, {27{1'b0}}};
		end
		1'b1: begin
			C_0_shifted = {{18{1'b0}}, {C_0}, {C_0[8:0]}};
			C_1_shifted = {{18{1'b0}}, {C_1}, {9{1'b0}}};
			C_4_shifted = {{C_4}, {9{1'b0}}, {18{1'b0}}};
			C_2_shifted = {{18{1'b0}}, {C_2}, {9{1'b0}}};
			C_3_shifted = {{C_3}, {9{1'b0}}, {18{1'b0}}};
			C_5_shifted = {{C_5}, {27{1'b0}}};
		end
	endcase
end

// to assign output pairs 
reg [44:0] result_temp_0;
reg [46:0] result_temp_1;
always @ (*) begin
	result_temp_1 [26:0] = 27'b0;
	result_1 [26:0] = result_temp_1 [26:0];
	result_temp_0 [44:0] = {{2{((C_0_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_0_shifted [26:0]}} + {{2{((C_1_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_1_shifted [26:0]}} + {{2{((C_2_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_2_shifted [26:0]}} + {{2{((C_3_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_3_shifted [26:0]}} + {{2{((C_4_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_4_shifted [26:0]}} + {{2{((C_5_shifted[26])&(HALF_0))&((a_sign|b_sign))}},{C_5_shifted [26:0]}};
	result_0 [44:0] = {{(result_temp_0 [44:27])&(~({18{HALF_0}}))},{result_temp_0 [26:0]}};
	result_SIDM_carry[1:0] = result_temp_0 [28:27];
	result_temp_1 [46:27] = {{2{((C_0_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_0_shifted [44:27]}} + {{2{((C_1_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_1_shifted [44:27]}} + {{2{((C_2_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_2_shifted [44:27]}} + {{2{((C_3_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_3_shifted [44:27]}} + {{2{((C_4_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_4_shifted [44:27]}} + {{2{((C_5_shifted[44])&(HALF_0))&((a_sign|b_sign))}},{C_5_shifted [44:27]}};
	result_1 [44:27] = result_temp_1 [44:27];
	result_SIDM_carry[3:2] = result_temp_1 [46:45];
end


endmodule
